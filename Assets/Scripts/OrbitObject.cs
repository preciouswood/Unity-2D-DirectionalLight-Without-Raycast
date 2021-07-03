using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OrbitObject : MonoBehaviour
{
    float suroundingRadius;
    float suroundingSpeed;
    float rotateSpeed;

    float currentRad;

    void RandomSetup()
    {
        currentRad = Random.Range(-180f * Mathf.Deg2Rad, 180f * Mathf.Deg2Rad);
        suroundingRadius = Random.Range(1f, 8f);
        suroundingSpeed = Random.Range(-1f, 1f);
        rotateSpeed = Random.Range(-5f, 5f);

        Vector3 pos = new Vector3()
        {
            x = Mathf.Cos(currentRad) * suroundingRadius,
            y = Mathf.Sin(currentRad) * suroundingRadius,
        };
        transform.position = pos;
    }

    void Start()
    {
        RandomSetup();
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.R))
            RandomSetup();
    }

    void FixedUpdate()
    {
        transform.Rotate(Vector3.forward * rotateSpeed,Space.Self);
        Vector3 pos = new Vector3()
        {
            x = Mathf.Cos(currentRad) * suroundingRadius,
            y = Mathf.Sin(currentRad) * suroundingRadius,
        };
        transform.position = pos;

        currentRad += suroundingSpeed * Time.fixedDeltaTime;
    }
}
