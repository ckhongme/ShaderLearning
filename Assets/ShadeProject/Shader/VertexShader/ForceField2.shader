Shader "CK/Vertex/ForceField2"
{
	Properties
	{
		_MainTex("MainTexture", 2D) = "black" {}
		_Threshold("相交阈值", Range(0.0, 1)) = 1
		_ViewThreshold("视角阈值", Range(0.0, 2)) = 1
		_Color("高光颜色", Color) = (1,1,1,1)
	}

	SubShader
	{
		Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }
		LOD 100

		Pass
		{
			Cull Off		//关闭背面裁剪（半透需要看到背面）
			ZWrite Off		//关闭Z缓存写入（不遮挡其他东西时需要关闭）
			ZTest On		//打开深度测试（护盾需要被其他东西遮挡）
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			//定义深度图
			uniform sampler2D_float _CameraDepthTexture;
			fixed _Threshold;
			fixed _ViewThreshold;
			fixed4 _Color;

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float4 screenPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				float3 worldViewDir : TEXCOORD4;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldViewDir = UnityWorldSpaceViewDir(mul(unity_ObjectToWorld, v.vertex));
				o.screenPos = ComputeScreenPos(o.vertex);
				COMPUTE_EYEDEPTH(o.screenPos.z);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float4 final = tex2D(_MainTex, i.uv);
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 worldViewDir = normalize(i.worldViewDir);

				//法线方向和视角方向的点积
				fixed edge = 1 - abs(dot(worldNormal, worldViewDir)) * _ViewThreshold;
				//根据自身的场景坐标采样深度图得到当前位置的场景深度
				float sceneZ = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPos)));
				float selfZ = i.screenPos.z;
				float intersect = 1 - min((abs(sceneZ - selfZ)) / _Threshold, 1);
				return lerp(final,_Color,max(edge,intersect));
			}

			ENDCG
		}
	}
}