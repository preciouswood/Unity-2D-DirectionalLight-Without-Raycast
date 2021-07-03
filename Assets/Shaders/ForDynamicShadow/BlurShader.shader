Shader "Unlit/BlurShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target
            {
				fixed source = tex2D(_MainTex, i.uv).r;
                fixed isEmpty = 1-source;
				
				fixed suroundingPixel = tex2D(_MainTex, i.uv + fixed2(-1, 0) * 0.002).r * 0.25 * isEmpty;
				suroundingPixel += tex2D(_MainTex, i.uv + fixed2(1,  0) * 0.002).r * 0.3 * isEmpty;
				suroundingPixel += tex2D(_MainTex, i.uv + fixed2(0,  1) * 0.002).r * 0.3 * isEmpty;
				suroundingPixel += tex2D(_MainTex, i.uv + fixed2(0, -1) * 0.002).r * 0.3 * isEmpty;


				//col += tex2D(_MainTex, i.uv + fixed2(-1, -1) * 0.003).r * 0.0947416;
				//col += tex2D(_MainTex, i.uv + fixed2(-1, 0) * 0.003).r * 0.118318;
				//col += tex2D(_MainTex, i.uv + fixed2(-1, 1) * 0.003).r * 0.0947416;
				//col += tex2D(_MainTex, i.uv + fixed2(0, -1) * 0.003).r * 0.118318;
				//col += tex2D(_MainTex, i.uv + fixed2(0, 1) * 0.003).r * 0.118318;
				//col += tex2D(_MainTex, i.uv + fixed2(1, -1) * 0.003).r * 0.0947416;
				//col += tex2D(_MainTex, i.uv + fixed2(1, 0) * 0.003).r * 0.118318;
				//col += tex2D(_MainTex, i.uv + fixed2(1, 1) * 0.003).r * 0.0947416;

					
                return fixed4(source + suroundingPixel,0,0,0);
            }
            ENDCG
        }
    }
}
