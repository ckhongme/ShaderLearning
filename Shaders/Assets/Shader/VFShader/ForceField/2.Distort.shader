//扭曲
Shader "CK/VF/Distort"
{
	Properties
	{
		_NoiseTex("Noise Texture", 2D) = "white" {}						//噪声图，为了使uv的偏移变得随机
		_DistortStrength("DistortStrength", Range(0, 0.2)) = 0.01		//扭曲强度
		_DistortTimeFactor("DistortTimeFactor", Range(0,1)) = 0.2		//扭曲的事件系数（扭曲快慢）
	}

	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue" = "Transparent"}
		LOD 100

		ZWrite Off
		Cull Off

		GrabPass
		{
			"_GrabTempTex"
		}

		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _NoiseTex;
			float4 _NoiseTex_ST;

			sampler2D _GrabTempTex;
			float4 _GrabTempTex_ST;

			float _DistortStrength;
			float _DistortTimeFactor;
			
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 pos : SV_POSITION;
				float4 grabPos : TEXCOORD1;
			};
			
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.grabPos = ComputeGrabScreenPos(o.pos);
				o.uv = TRANSFORM_TEX(v.uv, _NoiseTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				//扭曲（通过uv的偏移来模拟扭曲： 首先对噪声图采样，采样的uv值随时间变化，输出一个随机值）
				float4 offset = tex2D(_NoiseTex, i.uv - _Time.y * _DistortTimeFactor);
				i.grabPos.xy -= offset.xy * _DistortStrength;
				
				fixed4 col = tex2Dproj(_GrabTempTex, i.grabPos);
				return col;
			}
			ENDCG
		}
	}
}
