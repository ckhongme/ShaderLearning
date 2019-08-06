//溶解
Shader "CK/Surface/Dissolve"
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
		
		CGPROGRAM
		#pragma target 3.0  
		#pragma surface surf BlinnPhong alpha

		//主贴图
		sampler2D _MainTex, _DissolveTex;
		float _DissolveTile, _DissolveStrength;
		half _DissolveEdge, _RimPower;
		half4 _DissolveColor, _AddColor;

		struct Input
		{
			float2 uv_MainTex;
			float2 uv_DissolveTex;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			// 对主材质进行采样  
			fixed4 color = tex2D(_MainTex, IN.uv_MainTex);
			float clipTexG = tex2D(_DissolveTex, IN.uv_MainTex / _DissolveTile).r;

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
						o.Albedo = color.rga * finalColor;
					}
				}
			}
			o.Alpha = color.a;
		}
		ENDCG
	}
}
