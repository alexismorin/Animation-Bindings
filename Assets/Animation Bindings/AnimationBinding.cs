using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimationBinding : MonoBehaviour
{
    [SerializeField]
    public float currentValue = 0f;
    [SerializeField]
    float maximumValue = 1f;

    [Space(10)]

    [SerializeField]
    KeyCode booleanInput = KeyCode.Space;
    [SerializeField]
    string axisInput = "Vertical";
    [SerializeField]
    float inputDelay = 0f;
    [SerializeField]

    [Space(10)]

    float inputNoiseMagnitude = 0f;
    [SerializeField]
    float inputNoiseSpeed = 1f;

    [HideInInspector]
    public List<AnimationLink> links = new List<AnimationLink>();

    void OnValidate()
    {
        gameObject.name = booleanInput.ToString() + " / " + axisInput + " - Maximum " + maximumValue + " - Noise " + inputNoiseMagnitude;
    }



    void Update()
    {
        float outputAdditiveNoise = 0f;

        if (inputNoiseMagnitude > 0)
        {
            outputAdditiveNoise = (Mathf.PerlinNoise(Time.timeSinceLevelLoad * inputNoiseSpeed, 0.5f) - 0.5f) * inputNoiseMagnitude;
        }

        if (!Input.GetKey(booleanInput))
        {
            if (axisInput != "")
            {
                currentValue = Input.GetAxis(axisInput) * maximumValue + outputAdditiveNoise;
            }

        }

        if (Input.GetKeyDown(booleanInput))
        {
            Invoke("Press", inputDelay);
        }

        if (Input.GetKeyUp(booleanInput))
        {
            Invoke("Release", inputDelay);
        }

    }

    void Press()
    {
        currentValue = maximumValue;

        for (int i = 0; i < links.Count; i++)
        {
            links[i].Click();
        }
    }

    void Release()
    {
        currentValue = 0f;
    }

}
