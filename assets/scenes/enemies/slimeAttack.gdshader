shader_type particles;

uniform float angle_step;
uniform float initial_velocity;

void start(){
    float degree_to_rad = PI / 180.0;

    if(RESTART_VELOCITY){
	    float angle1_rad = float(INDEX) * angle_step * degree_to_rad;
	    vec3 rot = vec3(sin(angle1_rad), 0.0, cos(angle1_rad));
	    VELOCITY = rot * initial_velocity;
	}
    if(RESTART_POSITION){
	    TRANSFORM[3] = vec4(0);
    }
}