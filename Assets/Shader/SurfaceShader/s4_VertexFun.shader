Shader "CK/Surface/VertexFun"
{  
    Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
        _BumpMap ("Bumpmap", 2D)= "bump" {}
        _RimColor ("RimColor", Color) = (0.0, 0.57, 0.55, 0.0)
        _RimPower ("RimPower", Range(0, 8.0))= 0.5
        _TouchColor("TouchColor", Color) = (1, 0.32, 0.32, 1)
	}

    Subshader
    {
        Tags { "RenderType" = "Transparent" }
        
        CGPROGRAM
        
        //告诉Unity将使用自定义的vert函数
        #pragma surface surf BlinnPhong

		sampler2D _MainTex;
        sampler2D _BumpMap;
        float4 _RimColor;
        float  _RimPower;
        float4 _TouchColor;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float3 viewDir;
            float3 worldPos;
        };

        void vert(inout appdata_full v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);
        }
        
        void surf (Input IN, inout SurfaceOutput o)
        {
			//2D纹理采样
			fixed4 color = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = color.rgb;
            o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));
            half rim = 1.0  - saturate(dot (normalize(IN.viewDir), o.Normal));

            float3 rimColor =  _RimColor.rgb;
            if(IN.worldPos.y > 0)
                rimColor = _TouchColor.rgb;

            //saturate 限制值于[0,1]之间
            o.Emission = rimColor * pow (rim, _RimPower);
            //透明
            //o.Alpha = 0.5; 
        }

        ENDCG
    }
    FallBack "Diffuse"
}


