Shader "CK/Vertex/ForceField4"
{
	Properties
	{
		[HDR]_Color("Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex("Particle Texture", 2D) = "white" {}
		_MeshOffset("MeshOffset", Float) = (0.2, 0.5, 0, 0)
	}

	SubShader
	{
		Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }

		Pass
		{
			Cull Off
			ZWrite Off
			ZTest On
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			// Upgrade NOTE: excluded shader from DX11; has structs without semantics (struct v2f members factor)
			#pragma exclude_renderers d3d11
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _Color;
			float _MeshOffset;

			struct v2f
			{
				float4 pos: SV_POSITION;		//裁剪空间的顶点坐标；（以SV开头的语义表示系统数值）
				float4 color: COLOR;			
				float2 uv : TEXCOORD0;
				float factor;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				v.vertex += float4 (v.normal * _MeshOffset, 0.0);
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord.xy;
				float3 worldPosition = mul(UNITY_MATRIX_M, v.vertex);
				float3 viewDirection = normalize(worldPosition - _WorldSpaceCameraPos);
				o.factor = (dot(UnityObjectToWorldNormal(v.normal), viewDirection));
				for (int ii = 0; ii < 4; ii++)
				{
					o.dist[ii] = distance(_CollisionPoints[ii].xyz, v.vertex.xyz);
				}
				return o;
			}

			fixed4 frag(v2f i) : COLOR
			{
				fixed4 finalColor;
				float2 uvNormal = UnpackNormal(tex2D(_NormalTex, i.uv * _NormalScale + float2 (_TilingX * _Time.y, _TilingY * _Time.y)));
				fixed3 color = tex2D(_MainTex, (i.uv) * _MainScale + uvNormal) * _Color * _Emission;
				float fallOff = saturate(pow(1.0 - i.factor, _FallOff) * pow(i.factor, _FallOff2));
				///Magic Number!
				half alpha = 0.01;
				alpha += saturate(pow(_CollisionTime.x, 0.5) - (float(i.dist[0]) / _MaxDistance)) * _BrightnessCollision * max(sign(_CollisionTime.x), 0.0);
				alpha += saturate(pow(_CollisionTime.y, 0.5) - (float(i.dist[1]) / _MaxDistance)) * _BrightnessCollision * max(sign(_CollisionTime.y), 0.0);
				alpha += saturate(pow(_CollisionTime.z, 0.5) - (float(i.dist[2]) / _MaxDistance)) * _BrightnessCollision * max(sign(_CollisionTime.z), 0.0);
				alpha += saturate(pow(_CollisionTime.w, 0.5) - (float(i.dist[3]) / _MaxDistance)) * _BrightnessCollision * max(sign(_CollisionTime.w), 0.0);
				finalColor.rgb = color;
				finalColor.a = alpha * pow(finalColor.b, 2.0);
				return finalColor;
			}

			ENDCG
		}
	}
}
