using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CommonEvents : MonoBehaviour
{

    void ParticleBurst()
    {
        GetComponent<ParticleSystem>().Emit(100);
    }

}
