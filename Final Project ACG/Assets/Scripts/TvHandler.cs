using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TvHandler : MonoBehaviour
{
    public GameObject instructions;
    public GameObject tvText;
    public GameObject screen;
    public Camera mainCamera;
    public Material mandelbrot;
    public Material tvStatic;

    private bool channel = false;
    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        if (Vector3.Distance(mainCamera.transform.position, gameObject.transform.position) <= 18f)
        {
            tvText.SetActive(true);
            if (tvText.activeSelf && Input.GetKeyDown(KeyCode.Return))
            {
                channel = !channel;
            }
            if (channel)
            {
                instructions.SetActive(true);
                screen.GetComponent<MeshRenderer>().material = mandelbrot;
            }
            if (!channel)
            {
                instructions.SetActive(false);
                screen.GetComponent<MeshRenderer>().material = tvStatic;
            }
        }
        else
        {
            instructions.SetActive(false);
            tvText.SetActive(false);
        }

    }
}
