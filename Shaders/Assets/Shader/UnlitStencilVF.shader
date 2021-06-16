// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/UnlitStencilVF" {
	Properties{
		_MainColor("MainColor",Color) = (1,1,1,1)
	}
	
	SubShader {
		// Tags { "Queue" = "Geometry""RenderType"="Opaque" }
		LOD 200
		
		Pass { 
			
			Stencil
			{
				Ref 1
				Comp Equal
			} 
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			fixed4 _MainColor;

			struct VertexInput {
				float4 v : POSITION;
				float4 color: COLOR;
				float2 texcoord : TEXCOORD0;
			};
			
			struct VertexOutput {
				float4 pos : SV_POSITION;
				float4 col : COLOR;
			};
			
			VertexOutput vert (VertexInput v)
			{
				VertexOutput o;
				o.pos = UnityObjectToClipPos(v.v);
				o.col = v.color;
				UNITY_TRANSFER_FOG(o,o.pos);
				return o;

				//	
				
				// return o;
			}
			
			fixed4 frag (VertexOutput o) : COLOR {
				return o.col*_MainColor;
			}

			ENDCG
		}
	}
}