using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimationBinding : MonoBehaviour
{
    [Header("Value Modulation")]

    [HideInInspector]
    [SerializeField]
    public float currentValue = 0f;
    [SerializeField]
    AnimationCurve animationCurve = AnimationCurve.EaseInOut(0f, 0f, 1f, 1f);

    [Space(10)]

    [Header("Input")]

    [SerializeField]
    KeyCode booleanInput = KeyCode.Space;
    [SerializeField]
    string axisInput = "Vertical";
    [SerializeField]
    float inputDelay = 0f;
    [SerializeField]

    [Space(10)]

    [Header("Noise")]

    float inputNoiseMagnitude = 0f;
    [SerializeField]
    float inputNoiseSpeed = 1f;

    [HideInInspector]
    public List<AnimationLink> links = new List<AnimationLink>();

    void OnValidate()
    {
        gameObject.name = booleanInput.ToString() + " / " + axisInput + " - Maximum " + animationCurve.keys[animationCurve.length - 1].value + " - Noise " + inputNoiseMagnitude;
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
                currentValue = animationCurve.Evaluate(Mathf.Abs(Input.GetAxis(axisInput))) * Input.GetAxis(axisInput) + outputAdditiveNoise;
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
        currentValue = animationCurve.keys[animationCurve.length - 1].value;

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
