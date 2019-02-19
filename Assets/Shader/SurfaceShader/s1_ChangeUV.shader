Shader "CK/Surface/ChangeUV"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		//缩放量
		_ScaleX("ScaleX", float) = 1.0
		_ScaleY("ScaleY", float) = 1.0
		
		//平移量
		_TranslateX("TranslateX", float) = 0.0
	    _TranslateY("TranslateY", float) = 0.0

		_Angle("Angle", float) = 0.0
	}

	SubShader
	{

		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM

		#pragma surface surf Lambert

		sampler2D _MainTex;
		float _ScaleX;
		float _ScaleY;
		float _TranslateX;
		float _TranslateY;
		float _Angle;

		struct Input
		{
			float2 uv_MainTex;
		};
		
		void surf(Input IN, inout SurfaceOutput o)
		{
			//缩放uv
			float2 uv = IN.uv_MainTex;
			uv = float2(uv.x * _ScaleX + _TranslateX, uv.y * _ScaleY + _TranslateY);

			//以纹理中心为旋转中心
			uv -= float2(0.5, 0.5);
			uv = float2((cos(_Angle)*uv.x - sin(_Angle)*uv.y), (sin(_Angle)*uv.x + cos(_Angle)*uv.y));
			//恢复纹理位置
			uv += float2(0.5, 0.5);

			//2D纹理采样
			fixed4 color = tex2D(_MainTex, uv);
			o.Alpha = color.a;
			o.Albedo = color.rgb;
		}

		ENDCG
	}

	Fallback "Diffuse"
}
