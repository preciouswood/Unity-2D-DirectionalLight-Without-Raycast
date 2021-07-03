Shader "Unlit/GetMinDistanceShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_TextureSizeCountDown ("Texture Size Count Down" , Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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
			float _TextureSizeCountDown;


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

			fixed4 frag (float2 uv : TEXCOORD0) : Color
            {
				float distance_1 = tex2D(_MainTex, uv).r;
				float distance_2 = tex2D(_MainTex, uv - float2(_TextureSizeCountDown, 0)).r;
				float result = min(distance_1, distance_2);
				return float4(result,0, 0, 1);

            }
            ENDCG
        }
    }
}
