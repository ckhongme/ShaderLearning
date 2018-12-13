Shader "CK/HighLight"
{
	Properties
	{
		_RimColor("RimColor", Color) = (0,0,0,0)
		_RimValue("RimValue", float) = 0
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM

		#pragma surface surf Lambert
		#pragma target 3.0

		half4 _RimColor;
		float _RimValue;

		struct Input
		{
			float3 viewDir;
		};

		void surf(Input In, inout SurfaceOutput o)
		{
			half rim = 1.0 - saturate(dot(normalize(In.viewDir), o.Normal));
			o.Emission = _RimColor.rgb * pow(rim, _RimValue);
		}

		ENDCG
	}

	Fallback "Diffuse"
}
