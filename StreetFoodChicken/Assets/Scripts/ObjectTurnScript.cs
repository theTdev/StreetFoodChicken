using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectTurnScript : MonoBehaviour
{
    private void FixedUpdate()
    {
        transform.Rotate(0, 180 * Time.deltaTime, 0);
        
        //Make it go up and down slowly
        transform.position = new Vector3(transform.position.x, transform.position.y + Mathf.Sin(Time.time) * 0.0008f, transform.position.z);
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            other.GetComponent<PlayerMovement>().CollectChicken();
            Destroy(this.gameObject);
        }
    }
}
