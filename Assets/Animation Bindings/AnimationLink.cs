using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimationLink : MonoBehaviour
{
    float gatheredValue;
    Vector3 startPosition;
    Vector3 startRotation;

    [SerializeField]
    AnimationBinding animationBinding = null;

    [Space(10)]

    [Header("Animatable Properties")]

    [SerializeField]
    bool positionX = false;
    [SerializeField]
    bool positionY = false;
    [SerializeField]
    bool positionZ = false;

    [Space(5)]

    [SerializeField]
    bool rotationX = false;
    [SerializeField]
    bool rotationY = false;
    [SerializeField]
    bool rotationZ = false;

    [Space(5)]

    [SerializeField]
    string customMethodName;

    void Start()
    {
        animationBinding.links.Add(this);

        startPosition = transform.localPosition;
        startRotation = transform.localEulerAngles;
    }


    // LateUpdate is better for smooth animation
    void LateUpdate()
    {
        // fetch value from the animation binding
        gatheredValue = animationBinding.currentValue;

        // position effectors
        Vector3 additivePosition = Vector3.zero;
        if (positionX)
        {
            additivePosition += new Vector3(gatheredValue, 0f, 0f);
        }
        if (positionY)
        {
            additivePosition += new Vector3(0f, gatheredValue, 0f);
        }
        if (positionZ)
        {
            additivePosition += new Vector3(0f, 0f, gatheredValue);
        }

        if (positionX || positionY || positionZ)
        {
            transform.localPosition = startPosition + additivePosition;
        }


        // rotation effectors
        Vector3 additiveRotation = Vector3.zero;
        if (rotationX)
        {
            additiveRotation += new Vector3(gatheredValue, 0f, 0f);
        }
        if (rotationY)
        {
            additiveRotation += new Vector3(0f, gatheredValue, 0f);
        }
        if (rotationZ)
        {
            additiveRotation += new Vector3(0f, 0f, gatheredValue);
        }

        if (rotationX || rotationY || rotationZ)
        {
            transform.localEulerAngles = startRotation + additiveRotation;
        }
    }

    public void Click()
    {
        gameObject.SendMessage(customMethodName, SendMessageOptions.DontRequireReceiver);
    }
}
