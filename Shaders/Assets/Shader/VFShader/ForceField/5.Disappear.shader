//消失
Shader "CK/VF/Disappear"
{
	Properties
	{
		_MainTex("Main Texture", 2D) = "white" {}
		[Toggle]_DisappearDir("IsForwardDirection?", Float) = 0				//0是On，1是Off
		_DisappearVector("Disappear Vector", Vector) = (0,0,0,0)			//消失方向
		//[KeywordEnum(Top, Middle, Bottom)] _StartPos("Disappear StartPos", Float) = 0

		_DissolveColor("Rim Color", Color) = (0,0,0,0)
		_ColorFactor("ColorFactor", Range(0,1)) = 0.5
		_DissolveThreshold("DissolveThreshold", Float) = 0
	}

	SubShader
	{
		Tags {"RenderType" = "Opaque" }
		Cull Off

		Pass
		{
			CGPROGRAM
			
			//#pragma multi_compile _OVERLAY_Top _OVERLAY_Middle _OVERLAY_Bottom
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _DisappearDir;
			float4 _DisappearVector;
			fixed4 _DissolveColor;

			float _ColorFactor;
			float _DissolveThreshold;

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 worldNormal : NORMAL;
				float2 uv : TEXCOORD0;
				float3 worldLight : TEXCOORD1;
				float4 objPos : TEXCOORD2;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				//顶点转化到世界空间
				o.objPos = v.vertex;
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldLight = UnityObjectToWorldDir(_WorldSpaceLightPos0.xyz);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				half3 normal = normalize(i.worldNormal);
				half3 light = normalize(i.worldLight);
				
				//fixed diff = max(0, dot(normal, light));
				fixed4 col = tex2D(_MainTex, i.uv);
				
				float3 factor;

				//不满足条件的discard
				if (_DisappearDir <= 0)
				{
					factor = i.objPos.xyz - _DisappearVector.xyz;
				}
				else
					factor = _DisappearVector.xyz - i.objPos.xyz;

				clip(factor);

				//Diffuse + Ambient光照计算
				fixed3 lambert = saturate(dot(normal, light));
				fixed3 albedo = lambert * _LightColor0.xyz + UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 color = col.rgb * albedo;

				fixed lerpFactor = saturate(sign(_ColorFactor - factor));
				return lerpFactor * _DissolveColor + (1 - lerpFactor) * fixed4(color, 1);
			}

			ENDCG
		}
	}
	Fallback "Diffuse"
}
