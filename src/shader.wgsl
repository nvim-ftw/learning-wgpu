// Vertex shader

struct VertexInput {
    @location(0) position: vec3<f32>,
    @location(1) color: vec3<f32>,
};

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
    @location(0) frag_coord: vec4<f32>,
    @location(1) color: vec3<f32>,
};

@vertex
fn vs_main(
    model: VertexInput,
) -> VertexOutput {
    var out: VertexOutput;
    out.clip_position = vec4<f32>(model.position, 1.0);
    out.frag_coord = out.clip_position;
    out.color = model.color;
    return out;
}

// Fragment shader

@group(0) @binding(0)
var<uniform> res: vec2<u32>;


@group(1) @binding(0)
var<uniform> circle_radius: f32;

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let used_circle_radius = min(0.75 * f32(res.y), circle_radius);
    //if res.height * 0.75 < res.width {
    //    used_circle_radius
    //}
    let aspect_ratio = f32(res.x) / f32(res.y);
    let frag_coord = in.frag_coord.xy / in.frag_coord.w; // Normalize the window-relative coordinates
    let circle_center = vec2<f32>(0.0, 0.0); // Center of the circle in normalized device coordinates
    //let circle_radius = 0.25; // Radius of the circle in normalized device coordinates

    let dist = distance(frag_coord / vec2<f32>(1, aspect_ratio), circle_center);
    if dist > used_circle_radius {
        discard;
    }

    return vec4<f32>(in.color, 1.0); // Black color
}
