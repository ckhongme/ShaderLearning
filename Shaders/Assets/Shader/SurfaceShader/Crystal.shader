Shader "CK/Surface/Crystal"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_NormalMap("NomalMap", 2D) = "bump" {}
		_RimColor("Rim Color", Color) = (0.46,0.0,1.0,0.0)
		_RimPower("Rim Power", Range(0.2,2.0)) = 0.5
		_Brightness("Brightness",Range(0.0,3.0)) = 1.0
	}
		
	SubShader
	{
		Tags { "RenderType" = "Transparent" "Queue" = "Transparent" "IgnoreProjector" = "True"}

		CGPROGRAM
			
		#pragma surface surf Lambert alpha noambient nolightmap nodirlightmap novertexlights
			
		struct Input 
		{
			float2 uv_MainTex;
			float2 uv_NormalMap;
			float3 viewDir;
		};

		sampler2D _MainTex;
		sampler2D _NormalMap;
		float4 _RimColor;
		float _RimPower;
		float _Brightness;

		//边缘光照
		void surf(Input IN, inout SurfaceOutput o)
		{
			half4 basecol = tex2D(_MainTex, IN.uv_MainTex);
			half3 graycol = dot(basecol.rgb,float3(0.3,0.59,0.11));
			o.Albedo = graycol;
			o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
			half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
			o.Emission = _RimColor.rgb * pow(rim, _RimPower) * _Brightness;
			o.Alpha = (o.Emission.r + o.Emission.g + o.Emission.b) / 3.0;
		}

		ENDCG
	}

	Fallback "Diffuse"
}