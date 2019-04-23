Shader "CK/Vertex/VertexSample"
{
	Properties
	{
		[HDR]_Color("Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex("Particle Texture", 2D) = "white" {}
		_Speed("Speed", Range(-50,50.0)) = 1.0
		//_Scale("Scale", Range(0.5,500.0)) = 3.0
		//_Params("Params", Float) = (0.2, 0.5, 0, 0)
	}

	SubShader
	{
		Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
		LOD 200

		Cull Off		//关闭背面裁剪（半透时需要看到背面）
		ZWrite Off		//关闭深度缓存写入（不遮挡其他东西时需要关闭）
		ZTest On		//打开深度测试（需要被其他物体遮挡时需要打开）
		Blend SrcAlpha One

		//Lighting Off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _Color;
			half _Speed;
			float4 _MainTex_ST;

			struct a2v
			{
				float4 position: POSITION;		//顶点坐标
				float4 normal: NORMAL;			//法线方向
				float2 texcoord: TEXCOORD0;		//纹理坐标  (常用的是2维的普通纹理贴图，uv分别存在texcoord.xy中）
				float4 color: COLOR;
			};

			struct v2f
			{
				float4 pos: SV_POSITION;		//裁剪空间的顶点坐标；（以SV开头的语义表示系统数值）
				float4 color: COLOR;			
				float2 texcoord : TEXCOORD0;
			};

			v2f vert (a2v v)
			{
				v2f o;
				o.color = v.color;
				o.pos = UnityObjectToClipPos(v.position);		//顶点转换函数： 变换到齐次坐标系； 代替：mul(UNITY_MATRIX_MVP,*)
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}
			
			float4 frag(v2f i) : SV_Target
			{
				half t = _Time.y * _Speed;

				float4 mainTex = tex2D(_MainTex, i.texcoord + t);
				float4 color = i.color * mainTex;
				return color;
			}

			ENDCG
		}
	}
}
