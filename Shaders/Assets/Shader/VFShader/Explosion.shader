Shader "CK/Vertex/Explosion"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Speed("Speed", Float) = 1
		_AccelerationValue("AccelerationValue", Float) = 10
		_OutFactor("OutFactor", Range(0.01, 0.1)) = 0.05
		_StayTime("StayTime", Range(1,10)) = 2
	}

	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma geometry geom
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2g
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct g2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				fixed4 col : COLOR;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			float _OutFactor;
			float _Speed;
			float _AccelerationValue;
			float _StartTime;
			float _StayTime;
			
			v2g vert(appdata_base v)
			{
				v2g o;
				o.vertex = v.vertex;
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.normal = v.normal;
				return o;
			}

			[maxvertexcount(12)]
			void geom(triangle v2g IN[3], inout TriangleStream<g2f> tristream)
			{
				g2f o;
				float realTime = _Time.y - _StartTime;
				if (realTime < _StartTime)
				{
					float3 edgeA = IN[1].vertex - IN[0].vertex;
					float3 edgeB = IN[2].vertex - IN[0].vertex;
					float3 normalFace = normalize(cross(edgeA, edgeB));

					float3 centerPos = (IN[0].vertex + IN[1].vertex + IN[2].vertex) / 3;
					float2 centerTex = (IN[0].uv + IN[1].uv + IN[2].uv) / 3;
					centerPos -= float4(normalFace, 0) * _OutFactor;
				
					float3 moveVector = float3(0, 0, 0);
					moveVector = normalFace * (_Speed * realTime + .5 * _AccelerationValue * pow(realTime, 2));

					o.vertex = UnityObjectToClipPos(IN[2].vertex + moveVector);
					o.uv = IN[2].uv;
					o.col = fixed4(1.0, 1.0, 1.0, 1.);
					tristream.Append(o);

					o.vertex = UnityObjectToClipPos(IN[1].vertex + moveVector);
					o.uv = IN[1].uv;
					o.col = fixed4(1.0, 1.0, 1.0, 1.);
					tristream.Append(o);

					o.vertex = UnityObjectToClipPos(IN[0].vertex + moveVector);
					o.uv = IN[0].uv;
					o.col = fixed4(1.0, 1.0, 1.0, 1.);
					tristream.Append(o);

					tristream.RestartStrip();

					for (uint i = 0; i < 3; i++)
					{
						o.vertex = UnityObjectToClipPos(IN[i].vertex + moveVector);
						o.uv = IN[i].uv;
						o.col = fixed4(0., 0., 0., 1.);
						tristream.Append(o);

						uint index = (i + 1) % 3;
						o.vertex = UnityObjectToClipPos(IN[index].vertex + moveVector);
						o.uv = IN[index].uv;
						o.col = fixed4(0., 0., 0., 1.);
						tristream.Append(o);

						o.vertex = UnityObjectToClipPos(float4(centerPos, 1) + moveVector);
						o.uv = centerTex;
						o.col = fixed4(1.0, 1.0, 1.0, 1.);
						tristream.Append(o);

						tristream.RestartStrip();
					}
				}
			}
			
			fixed4 frag (g2f i) : SV_Target
			{
				float realTime = _Time.y - _StartTime;
				fixed4 col = tex2D(_MainTex, i.uv) * i.col;
				return col;
			}
			ENDCG
		}
	}
}
