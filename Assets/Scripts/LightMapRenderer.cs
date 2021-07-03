using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
[ExecuteInEditMode]
public class LightMapRenderer : MonoBehaviour
{
    Camera renderCamera;
    public bool isObstacleTransparent = true;
    [Range(256, 2048)]
    public int renderTextureSize;
    [Range(0, 5)]
    public int blurTimes;
    public LayerMask obstacleLayerMask;
    public Shader blackShader_Transparent, blackShader_Opaque, exetesionDistanceShader, getMinDistanceShader, shadowSamplerShader, blurShader;
    public Material lightShapeMat;
    
    Material exetesionDistanceMat, getMinDistanceMat, shadowSamplerMat, blurMat;

    RenderTexture source, target;
    Dictionary<int, RenderTexture> RenderTexturesDict;

    GameObject lightMesh;

    // Start is called before the first frame update
    void Awake()
    {
        if (renderTextureSize != 256 && renderTextureSize != 512 && renderTextureSize != 1024 && renderTextureSize != 2048)
        {
            if (renderTextureSize < 512)
                renderTextureSize = 256;
            else if (renderTextureSize > 512 && renderTextureSize < 1024)
                renderTextureSize = 512;
            else if (renderTextureSize > 1024 && renderTextureSize < 2048)
                renderTextureSize = 1024;
            else
                renderTextureSize = 2048;
        }




        exetesionDistanceMat = new Material(exetesionDistanceShader);
        getMinDistanceMat = new Material(getMinDistanceShader);
        shadowSamplerMat = new Material(shadowSamplerShader);
        blurMat = new Material(blurShader);

        source = new RenderTexture(renderTextureSize, renderTextureSize, 0, RenderTextureFormat.RHalf);
        //source.name = "Source";
        target = new RenderTexture(renderTextureSize, renderTextureSize, 0, RenderTextureFormat.RHalf);
        //target.name = "Target";

        RenderTexturesDict = new Dictionary<int, RenderTexture>();

        for (int i = renderTextureSize; i > 0; i /= 2)
        {
            RenderTexture RT = new RenderTexture(i, renderTextureSize, 0)
            {
                filterMode = FilterMode.Point,
                wrapMode = TextureWrapMode.Clamp,
                format = RenderTextureFormat.RGHalf,
            };

            RenderTexturesDict.Add(i, RT);

        }

        renderCamera = GetComponent<Camera>();
        renderCamera.orthographic = true;
        renderCamera.cullingMask = obstacleLayerMask;
        renderCamera.targetTexture = source;
        renderCamera.enabled = false;
    }

    // Update is called once per frame
    void Update()
    {
        RenderLightShapeToTargetTexture();
        SetTextureToLightMaterial();
    }



    void RenderLightShapeToTargetTexture()
    {

        if (isObstacleTransparent)
            renderCamera.RenderWithShader(blackShader_Transparent, null);
        else
            renderCamera.RenderWithShader(blackShader_Opaque, null);

        Graphics.Blit(source, RenderTexturesDict[renderTextureSize], exetesionDistanceMat);



        for (int i = renderTextureSize; i > 1; i /= 2)
        {
            getMinDistanceMat.SetFloat("_TextureSizeCountDown", 1f / i);
            Graphics.Blit(RenderTexturesDict[i], RenderTexturesDict[i / 2], getMinDistanceMat);
        }


        Graphics.Blit(RenderTexturesDict[1], target, shadowSamplerMat);


        for (int i = 0; i < blurTimes; i++)
        {
            RenderTexture tempRT = RenderTexture.GetTemporary(renderTextureSize, renderTextureSize, 0, RenderTextureFormat.RHalf);
            //RenderTexture tempRT = new RenderTexture(target);

            Graphics.Blit(target, tempRT, blurMat);
            Graphics.Blit(tempRT, target, blurMat);

            RenderTexture.ReleaseTemporary(tempRT);
            //tempRT.Release();
        }
    }

    void SetTextureToLightMaterial()
    {
        if (lightShapeMat != null)
            lightShapeMat.SetTexture("_MainTex", target);
    }


    void OnDrawGizmos()
    {
        Gizmos.DrawWireSphere(transform.position,0.5f);
    }
}
