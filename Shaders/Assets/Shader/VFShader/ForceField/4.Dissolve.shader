//溶解
Shader "CK/VF/Dissolve"
{
	Properties
	{
		_MainTex("Main Texture", 2D) = "white" {}						//
		_DissolveTex("Dissolve Texture", 2D) = "white" {}				//溶解贴图（噪声图）
		_DissolveTile("Dissolve Texture Tile", Range(0,1)) = 1			//溶解贴图的平铺系数
		_DissolveStrength("Dissolve Strength", Range(0, 1)) = 0.5		//溶解强度
		_DissolveVector("DissolveVector", Vector) = (0,0,0,0)			//溶解方向

		_DissSize("DissSize", Range(0, 1)) = 0.1
		_DissColor("DissColor", Color) = (1,0,0,1)
		_AddColor("AddColor", Color) = (1,1,0,1)
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }

		Pass
		{
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			//主贴图
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _DissolveTex;
			float4 _DissolveTex_ST;
			float _DissolveTile;
			float _DissolveStrength;
			half _DissSize;
			half4 _DissColor, _AddColor;
			

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _DissolveTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{	
				fixed4 color = tex2D(_MainTex, i.uv);

				float ClipTex = tex2D(_DissolveTex, i.uv / _DissolveTile).r;
				float ClipAmount = ClipTex - _DissolveStrength;
				if (_DissolveStrength > 0)
				{
					if (ClipAmount < 0)
					{
						clip(-0.1);
					}
					else 
					{
						if (ClipAmount < _DissSize)
						{
							float4 finalColor = lerp(_DissColor, _AddColor, ClipAmount / _DissSize) * 2;
							color = color * finalColor;
						}
					}
				}
				UNITY_OPAQUE_ALPHA(color.a);
				return color;
			}
			ENDCG
		}
	}

	Fallback "Diffuse"
}