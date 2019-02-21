Shader "CK/Surface/AboutWorldPos"
{  
    Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
        _Alpha("Alpha", Range(0, 1)) = 0.5
	}

    Subshader
    {
        Tags { "RenderType" = "Opaque" }
        
        CGPROGRAM
        
        #pragma surface surf Lambert alpha

		sampler2D _MainTex;
        float _Alpha;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };
        
        void surf (Input IN, inout SurfaceOutput o)
        {
			//2D纹理采样
			fixed4 color = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = color.rgb;
            if (IN.worldPos.y > 0)
                o.Alpha = _Alpha;
            else
                o.Alpha = color.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
