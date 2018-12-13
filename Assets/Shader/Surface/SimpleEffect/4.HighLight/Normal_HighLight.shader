Shader "CK/TestShader"
{
	Properties
	{
		_Color("Color", Color) = (0,0,0,0)
		_MainTex("Base(RGB)", 2D) = "white"{}
		_NormalTex("Normal", 2D) = "white"{}

		_RimColor("RimColor", Color) = (0,0,0,0)
		_RimValue("RimValue", float) = 0
	}

	SubShader
	{

	Tags { "RenderType" = "Opaque" }
	LOD 200

	CGPROGRAM

	//#pragma surface surf Lambert
	#pragma surface surf CustomDiffuse

	float4 _Color;
	sampler2D _MainTex;
	sampler2D _NormalTex;
	float4 _RimColor;
	float _RimValue;

	struct Input
	{
		float2 uv_MainTex;
		float2 uv_NormalTex;
		float viewDir;
		float3 worldNormal; INTERNAL_DATA		//输入点的世界法线方向
	};

	void surf(Input In, inout SurfaceOutput o)
	{
		float4 c = tex2D(_MainTex, In.uv_MainTex);
		o.Albedo = c.rgb;
		o.Alpha = c.a;

		float3 normalMap = UnpackNormal(tex2D(_NormalTex, In.uv_NormalTex));
		o.Normal = normalMap.rgb;

		half rim = 1.0 - saturate(dot(normalize(In.viewDir), In.worldNormal));
		o.Emission = _RimColor.rgb * pow(rim, _RimValue);
	}

	float4 LightingCustomDiffuse(SurfaceOutput s, fixed3 lightDir, fixed atten)
	{
		float4 difLight = max(0, dot(s.Normal, lightDir));
		float4 col;
		col.rgb = s.Albedo * _LightColor0.rgb * difLight * atten * 2; 
		col.a = s.Alpha;
		return col;
	}

	ENDCG

	}

	Fallback "Diffuse"
}