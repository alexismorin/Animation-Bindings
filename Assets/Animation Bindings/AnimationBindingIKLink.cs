using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimationBindingIKLink : MonoBehaviour
{
    [SerializeField]
    Animator animator;

    [Space(10)]

    [SerializeField]
    Transform leftHandIKHandle;
    [SerializeField]
    AnimationBinding leftHandIKBinding;

    [Space(5)]

    [SerializeField]
    Transform rightHandIKHandle;
    [SerializeField]
    AnimationBinding rightHandIKBinding;

    [Space(5)]

    [SerializeField]
    Transform leftFootIKHandle;
    [SerializeField]
    AnimationBinding leftFootIKBinding;

    [Space(5)]

    [SerializeField]
    Transform rightFootIKHandle;
    [SerializeField]
    AnimationBinding rightFootIKBinding;

    void OnAnimatorIK()
    {
        if (leftHandIKHandle)
        {
            animator.SetIKPosition(AvatarIKGoal.LeftHand, leftHandIKHandle.transform.position);
            if (leftHandIKBinding)
            {
                animator.SetIKPositionWeight(AvatarIKGoal.LeftHand, leftHandIKBinding.currentValue);
            }
            else
            {
                animator.SetIKPositionWeight(AvatarIKGoal.LeftHand, 1f);
            }

        }
        if (rightHandIKHandle)
        {
            animator.SetIKPosition(AvatarIKGoal.RightHand, rightHandIKHandle.transform.position);
            if (rightHandIKBinding)
            {
                animator.SetIKPositionWeight(AvatarIKGoal.RightHand, rightHandIKBinding.currentValue);
            }
            else
            {
                animator.SetIKPositionWeight(AvatarIKGoal.RightHand, 1f);
            }

        }
        if (leftFootIKHandle)
        {
            animator.SetIKPosition(AvatarIKGoal.LeftFoot, leftFootIKHandle.transform.position);
            if (leftFootIKBinding)
            {
                animator.SetIKPositionWeight(AvatarIKGoal.LeftFoot, leftFootIKBinding.currentValue);
            }
            else
            {
                animator.SetIKPositionWeight(AvatarIKGoal.LeftFoot, 1f);
            }

        }
        if (rightFootIKHandle)
        {
            animator.SetIKPosition(AvatarIKGoal.RightFoot, rightFootIKHandle.transform.position);
            if (rightFootIKBinding)
            {
                animator.SetIKPositionWeight(AvatarIKGoal.RightFoot, rightFootIKBinding.currentValue);
            }
            else
            {
                animator.SetIKPositionWeight(AvatarIKGoal.RightFoot, 1f);
            }

        }
    }
}
