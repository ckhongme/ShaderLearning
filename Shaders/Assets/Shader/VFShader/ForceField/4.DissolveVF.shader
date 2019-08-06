//溶解
Shader "CK/VF/Dissolve"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}						//主贴图
		_DissolveTex("DissolveTex(R)", 2D) = "white" {}				//溶解贴图（噪声图）
		_DissolveStrength("Dissolve Strength", Range(0, 1)) = 0.5	//溶解强度
		_DissolveTile("DissolveTex Tile", Range(0,1)) = 1			//溶解贴图的平铺系数
	    
		_DissolveColor("DissolveColor", Color) = (1,0,0,1)			//溶解主色
		_AddColor("AddColor", Color) = (1,1,0,1)					//溶解效果叠加色
		_DissolveEdge("DissolveEdge", Range(0, 1)) = 0.1			//溶解的边缘大小
		_RimPower("RimPower", Float) = 2							//发光强度
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		Cull Off

		Pass
		{
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			//主贴图
			sampler2D _MainTex, _DissolveTex;
			float4 _DissolveTex_ST;
			float _DissolveTile, _DissolveStrength;
			half _DissolveEdge, _RimPower;
			half4 _DissolveColor, _AddColor;
			
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
				o.uv = TRANSFORM_TEX(v.uv, _DissolveTex);  //确保材质球面板的缩放和偏移设置能起作用，等价于 o.uv = v.uv.xy * _DissolveTex_ST.xy + _DissolveTex_ST.zw;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{	
				fixed4 color = tex2D(_MainTex, i.uv);
				float clipTexG = tex2D(_DissolveTex, i.uv / _DissolveTile).r;

				if (_DissolveStrength > 0)
				{
					float clipAmount = clipTexG - _DissolveStrength;
					if (clipAmount < 0)
					{
						discard; //裁剪
					}
					else 
					{
						if (clipAmount < _DissolveEdge)
						{
							float4 finalColor = lerp(_DissolveColor, _AddColor, clipAmount / _DissolveEdge) * _RimPower;
							color = color * finalColor;
						}
					}
				}
				return color;
			}
			ENDCG
		}
	}

	Fallback "Diffuse"
}