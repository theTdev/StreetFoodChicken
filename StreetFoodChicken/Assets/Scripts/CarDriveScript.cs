using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

public class CarDriveScript : MonoBehaviour
{
    public bool driveReverse = false;
    public float spawnHeight = 0F;
    public float maxSpeed = 0.3F;
    public float minSpeed = 0.1F;
    public float speed = 0F;
    
    private void Start()
    {
        this.transform.position = new Vector3(this.transform.position.x, spawnHeight, this.transform.position.z);
        speed = Random.Range(minSpeed, maxSpeed);
    }
    
    private void FixedUpdate()
    {
        Vector3 movement = new Vector3(driveReverse ? -speed : speed, 0, 0);
        this.gameObject.transform.Translate(Vector3.right * speed);
    }
}
