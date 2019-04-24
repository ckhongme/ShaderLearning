Shader "CK/Vertex/ForceField"
{
	Properties
	{
		_MainTex("Main Texture", 2D) = "white" {}
		_NoiseTex("Noise Texture", 2D) = "white" {}		//噪声图，为了使uv的偏移变得随机
		_RimColor("RimColor", Color) = (0,0,0,0)
		_RimPower("RimPower", Range(0.0, 2)) = 1	

		_DistortStrength("DistortStrength", Range(0, 0.2)) = 0.01		//扭曲强度
		_DistortTimeFactor("DistortTimeFactor", Range(0,1)) = 0.2		//扭曲的事件系数
		_IntersectPower("IntersectPower", Range(0, 3)) = 2
	}

	SubShader
	{
		Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }

		Cull Off		//关闭背面裁剪（半透需要看到背面）
		ZWrite Off		//关闭Z缓存写入（不遮挡其他东西时需要关闭）
		Blend SrcAlpha OneMinusSrcAlpha

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
			#pragma target 3.0

			//定义深度图
			sampler2D _CameraDepthTexture;
			//抓屏贴图
			sampler2D _GrabTempTex;
			float4 _GrabTempTex_ST;
			
			sampler2D _MainTex;
			float4 _MainTex_ST;

			sampler2D _NoiseTex;
			float4 _NoiseTex;
		
			fixed4 _RimColor;
			float _RimPower;
			float _DistortStrength;
			float _DistortTimeFactor;
			float _IntersectPower;

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
				float4 pos : SV_POSITION;
				
				//不使用多重纹理时，可以用来存放动态计算的信息；
				float4 screenPos : TEXCOORD1;
				float4 grabPos : TEXCOORD2;
				float3 viewDir : TEXCOORD3;

			};

			v2f vert(appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.grabPos = ComputeGrabScreenPos(o.pos);		//计算抓屏的位置；从（-1，1）转到（0，1）空间
				o.uv = TRANSFORM_TEX(v.uv, _NoiseTex);
				

				o.screenPos = ComputeScreenPos(o.pos);		
				COMPUTE_EYEDEPTH(o.screenPos.z);		//计算顶点摄像机空间的深度：距离裁剪平面的距离，线性变化

				o.normal = UnityObjectToWorldNormal(v.normal);
				o.viewDir = normalize(UnityWorldSpaceViewDir(mul(unity_ObjectToWorld, v.vertex)));

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{	
				//获取深度信息: 根据自身的场景坐标采样深度图得到当前位置的场景深度（此时的深度图里没有力场的信息）
				float sceneZ = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPos)));
				float selfZ = i.screenPos.z;
				
				//判断相交
				float diff = sceneZ - selfZ;
				float intersect = (1 - diff) * _IntersectPower;
				
				//圆环
				float3 viewDir = normalize(UnityWorldSpaceViewDir(mul(unity_ObjectToWorld, i.pos)));
				float rim = 1 - abs(dot(i.normal, normalize(i.viewDir))) * _RimPower;
				float glow = max(intersect, rim);

				//扭曲
				float4 offset = tex2D(_NoiseTex, i.uv - _Time.y * _DistortTimeFactor);
				i.grabPos.xy -= offset.xy * _DistortStrength;
				
				//Grab贴图采样
				fixed4 color = tex2Dproj(_GrabTempTex, i.grabPos);
				fixed4 col = _RimColor * glow + color;
				return col;
			}

			ENDCG
		}
	}
}