Shader "CK/Surface/SimpleSurface"
{  
   Subshader
   {
       Tags { "RenderType" = "Opaque" }
       
	   CGPROGRAM
       
	   #pragma surface surf Lambert
       struct Input
	   {
           float4 color : COLOR;
           float3 worldPos;
       };
       
	   void surf (Input IN, inout SurfaceOutput o)
	   {
           o.Albedo = 1;
           if (IN.worldPos.y > 1)
                o.Albedo = 2;
       }
       ENDCG
   }
   FallBack "Diffuse"
}