FROM python:3.10 as builder

LABEL maintainer="Aderemi Adesada <adesadaaderemi@gmail.com>"

USER root

# RUN apt-get install --no-install-recommends -q -y subversion

RUN apt-get install --no-install-recommends -q -y make gcc g++ libffi-dev

# # Install dependencies
# RUN apt-get update && apt-get install --no-install-recommends -q -y \
# 	libxi-dev \ 
# 	libxxf86vm-dev \
#     libxkbcommon-x11-0 \
# 	&& rm -rf /var/lib/apt/lists/*

ARG GENESYS_VERSION

RUN pip install --upgrade pip wheel setuptools \
    && pip install genesys==${GENESYS_VERSION} \
    && apt-get purge -y make gcc g++ libffi-dev \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir temp_addon \
    && mv /usr/local/lib/python3.10/site-packages/bpy/3.4/scripts/addons/io_anim_bvh/ temp_addon \
    && mv /usr/local/lib/python3.10/site-packages/bpy/3.4/scripts/addons/io_curve_svg/ temp_addon \
    && mv /usr/local/lib/python3.10/site-packages/bpy/3.4/scripts/addons/io_mesh_ply/ temp_addon \
    && mv /usr/local/lib/python3.10/site-packages/bpy/3.4/scripts/addons/io_mesh_stl/ temp_addon \
    && mv /usr/local/lib/python3.10/site-packages/bpy/3.4/scripts/addons/io_mesh_uv_layout/ temp_addon \
    && mv /usr/local/lib/python3.10/site-packages/bpy/3.4/scripts/addons/io_scene_obj/ temp_addon \
    && mv /usr/local/lib/python3.10/site-packages/bpy/3.4/scripts/addons/io_scene_fbx/ temp_addon \
    && mv /usr/local/lib/python3.10/site-packages/bpy/3.4/scripts/addons/io_scene_gltf2/ temp_addon \
    && mv /usr/local/lib/python3.10/site-packages/bpy/3.4/scripts/addons/io_scene_x3d/ temp_addon \
    && mv /usr/local/lib/python3.10/site-packages/bpy/3.4/scripts/addons/pose_library/ temp_addon \
	&& rm -R /usr/local/lib/python3.10/site-packages/bpy/3.4/scripts/addons/* \
    && mv temp_addon/* /usr/local/lib/python3.10/site-packages/bpy/3.4/scripts/addons/ \
    && rm -R temp_addon\
	&& useradd eaxum \
	&& chown -R eaxum:eaxum /usr/local/lib/python3.10/

FROM python:3.10
COPY --from=builder /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -q -y \
	subversion\
	libxi-dev \ 
	libxxf86vm-dev \
    libxkbcommon-x11-0 \
	&& rm -rf /var/lib/apt/lists/* \
	&& useradd eaxum \
	&& chown -R eaxum:eaxum /usr/local/lib/python3.10/

USER eaxum


ENV GENESYS_FOLDER /usr/local/lib/python3.10/site-packages/genesys
WORKDIR ${GENESYS_FOLDER}