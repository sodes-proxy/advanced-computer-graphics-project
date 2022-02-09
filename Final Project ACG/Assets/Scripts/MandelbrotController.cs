using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MandelbrotController : MonoBehaviour
{
    public Material mandelbrotM;
    public Vector2 Position;
    public float scale, angle;
    private float _AspectRatio, _SmoothScale, _SmoothAngle;
    private Vector2 _SmoothPos;
    private float _symmetry = 0f;

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            if (_symmetry == 0f)
            {
                _symmetry = 1f;
            }
            else
            {
                _symmetry = 0f;
            }
            mandelbrotM.SetFloat("symmetry", _symmetry);
        }
    }
    void FixedUpdate()
    {
        if (Input.GetKey(KeyCode.U))
        {
            angle -= 0.01f;
        }
        if (Input.GetKey(KeyCode.O))
        {
            angle += 0.01f;
        }
        if (Input.GetKey(KeyCode.UpArrow))
        {
            scale *= 0.99f;
        }
        if (Input.GetKey(KeyCode.DownArrow))
        {
            scale *= 1.01f;
        }
        Vector2 direction = new Vector2(0.01f * scale, 0);
        float y = Mathf.Sin(angle);
        float x = Mathf.Cos(angle);
        direction = new Vector2(direction.x * x, direction.x * y);
        if (Input.GetKey(KeyCode.J))
        {
            Position -= direction;
        }
        if (Input.GetKey(KeyCode.L))
        {
            Position += direction;

        }
        direction = new Vector2(-direction.y, direction.x);
        if (Input.GetKey(KeyCode.I))
        {
            Position += direction;
        }
        if (Input.GetKey(KeyCode.K))
        {
            Position -= direction;

        }
        ShaderHandler();
    }
    /*
    Updates shader to zoom in or out of fractal and modifies its Position
    */
    private void ShaderHandler()
    {
        _SmoothPos = Vector2.Lerp(_SmoothPos, Position, 0.05f);
        _SmoothScale = Mathf.Lerp(_SmoothScale, scale, 0.03f);
        _SmoothAngle = Mathf.Lerp(_SmoothAngle, angle, 0.03f);
        _AspectRatio = (float)Screen.width / (float)Screen.height;
        float scaleX = _SmoothScale;
        float scaleY = _SmoothScale;
        if (_AspectRatio > 1f)
        {
            scaleY /= _AspectRatio;
        }
        else
        {
            scaleX *= _AspectRatio;
        }
        mandelbrotM.SetVector("area", new Vector4(_SmoothPos.x, _SmoothPos.y, scaleX, scaleY));
        mandelbrotM.SetFloat("angle", _SmoothAngle);
    }
}
