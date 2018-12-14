using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 着色器捆绑器 （用于Shader的热更）
/// 将需要用到的shader拖到捆绑器上，然后将捆绑器的prefab打包成assetbundle，在游戏开始前加载; 
/// runtime时，通过 ShaderBinder.Instance.GetShader()获取；
/// </summary>
public class ShaderBinder : MonoBehaviour
{
    [HideInInspector]
    public static ShaderBinder Instance;
    public ShaderVariantCollection shaderVariantCollection;

    [Header("please binding your shader here")]
    [SerializeField]
    private List<Shader> _shaders;

    void Awake()
    {
        if (Instance != null) return;

        DontDestroyOnLoad(gameObject);
        Instance = this;
        if (shaderVariantCollection != null)
        {
            shaderVariantCollection.WarmUp();
        }
        else
        {
            Shader.WarmupAllShaders();
        }
    }

    public Shader GetShader(string shaderName)
    {
        return _shaders.Find(x => x.name.Equals(shaderName));
    }
}