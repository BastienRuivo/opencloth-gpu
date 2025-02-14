#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec2 aTexCoord;

out vec3 ourNormal;
out vec2 shaderTexCoord;
out vec3 texPos;

uniform mat4 projection;
uniform mat4 view;
uniform mat4 model;

void main()
{
	gl_Position = projection * view * model * vec4(aPos, 1.0);
	texPos = aPos;
	ourNormal = aNormal;
	shaderTexCoord = aTexCoord;
}