//消失
Shader "CK/VF/Disappear"
{
	Properties
	{
		_MainTex("Main Texture", 2D) = "white" {}
		_DisappearVector("DissolveVector", Vector) = (0,0,0,0)			//消失方向
	}

	SubShader
	{
		Tags {"RenderType" = "Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert  
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform float4 _DisappearVector;

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
				fixed diff = max(0, dot(normal, light));
				fixed4 albedo = tex2D(_MainTex, i.uv);
				//不满足条件的discard  
				clip(i.objPos.xyz - _DisappearVector.xyz);
				fixed4 c;
				c.rgb = diff * albedo;
				c.a = 1;
				return c;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}