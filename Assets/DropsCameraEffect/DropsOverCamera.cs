using System;
using UnityEngine;
using System.Collections;
using Random = UnityEngine.Random;


public class DropsOverCamera : MonoBehaviour 
{
 
    const int MaxDrops = 64;
    
    [SerializeField] Material material;
    [SerializeField] Camera cam;
    
    [SerializeField] float averageRadius;
    [SerializeField] int dropsCount = 32;

    void OnValidate()
    {
        dropsCount = Mathf.Clamp( dropsCount,0, MaxDrops);
    }

    float[] dropsX; 
    float[] dropsY; 
    float[] dropsSizeX;
    float[] dropsSizeY;
    float[] dropsSpeedY;
    
    static readonly int DropsX = Shader.PropertyToID("dropsX");
    static readonly int DropsY = Shader.PropertyToID("dropsY");
    static readonly int DropsSizeX = Shader.PropertyToID("dropsSizeX");
    static readonly int DropsSizeY = Shader.PropertyToID("dropsSizeY");

    void Start()
    {
        dropsSpeedY = new float[64];
        dropsSizeY = new float[64];
        dropsSizeX = new float[64];
        dropsY = new float[64];
        dropsX = new float[64];
        
        SpawnAll();
    }

    void SpawnAll()
    {
        for (var i = 0; i < dropsCount; i++)
        {
            SpawnDrop(i);
        }
    }

    void OnRenderImage (RenderTexture source, RenderTexture destination)
    {
        material.SetFloatArray(DropsX,dropsX);
        material.SetFloatArray(DropsY,dropsY);
        material.SetFloatArray(DropsSizeX,dropsSizeX);
        material.SetFloatArray(DropsSizeY,dropsSizeY);
        Graphics.Blit (source, destination, material);
    }

    void UpdateDrop(int i)
    {
        var dt = Time.deltaTime;
        dropsY[i] += dropsSpeedY[i] * dt;
        if (dropsY[i] < -0.2f) SpawnDrop(i);
    }

    void SpawnDrop(int i)
    {
        dropsX[i] = Random.value;
        dropsY[i] = 1.25f;
        var rad = Random.Range(0.02f, 0.4f) * averageRadius;
        dropsSizeX[i] = rad / cam.aspect;
        dropsSizeY[i] = rad;
        dropsSpeedY[i] = - Random.value;
    }

    

    void Update()
    {
        for (var i = 0; i < dropsCount; i++)
        {
            UpdateDrop(i);
        }
    }
}