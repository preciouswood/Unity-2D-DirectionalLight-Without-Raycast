Shader "Unlit/LightShapeShader"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
		_MaskTex("Mask Texture",2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderQueue" = "Transparent + 1" "RenderType"="Transparent"  }
        LOD 100
		blend SrcAlpha OneMinusSrcAlpha
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

            sampler2D _MainTex;
            sampler2D _MaskTex;
            float4 _MainTex_ST;
			float _Flip;
			float _BlurRadius;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {


				half alpha = tex2D(_MainTex, i.uv).r;
				//
				//alpha += tex2D(_MainTex, i.uv + fixed2(-1,-1) * _BlurRadius).r * 0.0947416;
				//alpha += tex2D(_MainTex, i.uv + fixed2(-1, 0) * _BlurRadius).r * 0.118318;
				//alpha += tex2D(_MainTex, i.uv + fixed2(-1, 1) * _BlurRadius).r * 0.0947416;
				//alpha += tex2D(_MainTex, i.uv + fixed2(0, -1) * _BlurRadius).r * 0.118318;
				//alpha += tex2D(_MainTex, i.uv + fixed2(0,  1) * _BlurRadius).r * 0.118318;
				//alpha += tex2D(_MainTex, i.uv + fixed2(1, -1) * _BlurRadius).r * 0.0947416;
				//alpha += tex2D(_MainTex, i.uv + fixed2(1,  0) * _BlurRadius).r * 0.118318;
				//alpha += tex2D(_MainTex, i.uv + fixed2(1,  1) * _BlurRadius).r * 0.0947416;
				//half alpha = tex2D(_MainTex, i.uv).r * 0.1111111;
				//
				//alpha += tex2D(_MainTex, i.uv + fixed2(-1,-1) * _BlurRadius).r * 0.1111111;
				//alpha += tex2D(_MainTex, i.uv + fixed2(-1, 0) * _BlurRadius).r * 0.1111111;
				//alpha += tex2D(_MainTex, i.uv + fixed2(-1, 1) * _BlurRadius).r * 0.1111111;
				//alpha += tex2D(_MainTex, i.uv + fixed2(0, -1) * _BlurRadius).r * 0.1111111;
				//alpha += tex2D(_MainTex, i.uv + fixed2(0,  1) * _BlurRadius).r * 0.1111111;
				//alpha += tex2D(_MainTex, i.uv + fixed2(1, -1) * _BlurRadius).r * 0.1111111;
				//alpha += tex2D(_MainTex, i.uv + fixed2(1,  0) * _BlurRadius).r * 0.1111111;
				//alpha += tex2D(_MainTex, i.uv + fixed2(1,  1) * _BlurRadius).r * 0.1111111;



				//alpha *= 0.2;
				alpha *= tex2D(_MaskTex, i.uv).a * 0.7;

				return fixed4(1,1,1,alpha);
            }
            ENDCG
        }
    }
}
