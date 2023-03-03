using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CarDestroyerScript : MonoBehaviour
{
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Car"))
        {
            Destroy(other.gameObject);
        }
    }
}
