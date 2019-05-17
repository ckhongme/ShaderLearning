Shader "CK/Vertex/Dissolve"
{
	Properties
	{
		_MainTex("Main Texture", 2D) = "black" {}
		_DissolveTex("Dissolve Texture", 2D) = "white" {}				//溶解贴图
		_DissolveTexScale("Dissolve Texture Scale", Range(0,1)) = 1		//溶解贴图的大小
	
		_DissolveStrength("Dissolve Strength", Range(0, 1)) = 0.5		//溶解度
	}

	SubShader
	{
		Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }

		Cull Off		//关闭背面裁剪（半透需要看到背面）
		ZWrite Off		//关闭Z缓存写入（不遮挡其他东西时需要关闭）
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#pragma target 3.0

			//主贴图
			sampler2D _MainTex;
			float4 _MainTex_ST;

			sampler2D _DissolveTex;
			float _DissolveTexScale;
			float _DissolveStrength;
			

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.uv = TRANSFORM_TEX(v.uv, _NoiseTex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.viewDir = normalize(UnityWorldSpaceViewDir(mul(unity_ObjectToWorld, v.vertex)));

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{	
				fixed4 color = tex2D(_MainTex, i.uv);
				
				

				return col;
			}

			ENDCG
		}
	}
}