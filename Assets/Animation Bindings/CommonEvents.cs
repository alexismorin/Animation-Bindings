using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CommonEvents : MonoBehaviour
{


    // Emit a burst of particles on the local particle system
    void ParticleBurst()
    {
        GetComponent<ParticleSystem>().Emit(100);
    }

    // Destroy the local component.
    void DestroyComponent()
    {
        GetComponent<ParticleSystem>().Emit(100);
    }



}
