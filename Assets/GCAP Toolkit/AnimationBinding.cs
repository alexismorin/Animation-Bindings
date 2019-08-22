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
    float delay = 0f;

    [HideInInspector]
    public List<AnimationLink> links = new List<AnimationLink>();



    void OnValidate()
    {
        gameObject.name = booleanInput.ToString() + " / " + axisInput + " - Max. Value " + maximumValue;
    }



    void Update()
    {

        if (!Input.GetKey(booleanInput))
        {
            if (axisInput != "")
            {
                currentValue = Input.GetAxis(axisInput) * maximumValue;
            }

        }

        if (Input.GetKeyDown(booleanInput))
        {
            Invoke("Press", delay);
        }

        if (Input.GetKeyUp(booleanInput))
        {
            Invoke("Release", delay);
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
