// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Dexmo/HologramLine" 
{
    	Properties
		{
			[HDR]_Color("Color", Color) = (0.5,0.5,0.5,0.5)
			_MainTex("Particle Texture", 2D) = "white" {}
			_Scale("Scale", Range(0.5,500.0)) = 3.0
			_Speed("Speed", Range(-50,50.0)) = 1.0
			_Params("Params", Float) = (0.2, 0.5, 0, 0)
		}
			
		SubShader
		{
			Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
			
			Blend SrcAlpha One
			Cull Off 
			Lighting Off 
			ZWrite Off

			Pass 
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

				sampler2D _MainTex;
				fixed4 _Color, _Params;
				half _Scale, _Speed;
				float4 _MainTex_ST;

				struct a2v 
				{
					float4 position : POSITION;
					fixed4 color : COLOR;
					float2 texcoord : TEXCOORD0;
				};

				struct v2f 
				{
					float4 position : SV_POSITION;
					fixed4 color : COLOR;
					float2 texcoord : TEXCOORD0;
				};

				v2f vert(a2v v)
				{
					v2f o;
					o.color = v.color;
					o.position = UnityObjectToClipPos(v.position);
					o.texcoord = TRANSFORM_TEX(v.texcoord,_MainTex);
					return o;
				}

				float4 frag(v2f i) : SV_Target
				{
			        half2 uv = (i.texcoord - 0.5) * _Scale;
					half r = sqrt (uv.y*uv.y*_Params.x);
					half z = tan (r+_Time.y*_Speed) / r;

					if (r<_Params.z)
						discard;

					float4 mainTex = tex2D(_MainTex, i.texcoord + z);

					float4 color = i.color * mainTex;
					color.a = saturate(color.a);
					color *= _Color *  0.03;
					color *= frac((uv.x*_Params.y)*_Params.x)  * _Params.w;
					return color;
				}
				ENDCG
			}
			
		}
}