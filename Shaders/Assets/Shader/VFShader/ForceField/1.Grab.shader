//抓屏
Shader "CK/VF/Grab"
{
	SubShader
	{
		ZWrite Off

		//Unity提供的特殊Pass，可以直接将当前屏幕内容渲染到指定名称的贴图上；
		GrabPass
		{
			"_GrabTempTex"
		}

		Pass
		{
			Tags { "RenderType"="Transparent" "Queue" = "Transparent" }

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			//抓屏贴图
			sampler2D _GrabTempTex;
			float4 _GrabTempTex_ST;
			
			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 grabPos : TEXCOORD1;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.grabPos = ComputeGrabScreenPos(o.vertex);  //计算抓屏的位置；从（-1，1）转到（0，1）空间
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				//Grab贴图采样; tex2Dproj 相当于 tex2D(_GrabTempTex, grabPos.xy/grabPos.w), 采样点进行了一次投影变换
				fixed4 col = tex2Dproj(_GrabTempTex, i.grabPos);
				//为方便看效果，将输出的颜色反向
				return 1 - col;
			}
			ENDCG
		}
	}
}
