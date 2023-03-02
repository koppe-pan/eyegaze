import * as THREE from "three"
import { OrbitControls } from "three/examples/jsm/controls/OrbitControls.js"

const renderer = new THREE.WebGLRenderer({ alpha: true })
const camera = new THREE.PerspectiveCamera(
  15.0,
  window.innerWidth / window.innerHeight,
  0.1,
  50.0
)
const scene = new THREE.Scene()

let circle

const target = {
  mounted() {
    renderer.setSize(window.innerWidth, window.innerHeight)
    renderer.setPixelRatio(window.devicePixelRatio)

    this.el.appendChild(renderer.domElement)

    // camera
    camera.position.set(0.0, 1.3, 3.0)
    // camera controls
    const controls = new OrbitControls(camera, renderer.domElement)
    this.init_camera_controls(controls)

    // light
    const light = new THREE.DirectionalLight(0xffffff)
    light.position.set(1.0, 1.0, 1.0).normalize()
    scene.add(light)

    camera.add(circle)
    this.initPosition({x:0, y:0})
    console.log(circle)
    scene.add(circle)
    renderer.render(scene, camera)

    window.addEventListener("resize", this.onResize)

    this.handleEvent("changeRotation", (results) => {
      this.render(results)
    })
  },

  initPosition({ x, y }) {
    const shape = new THREE.Shape();

    const radius = 2;
    shape.absarc(x, y, radius);

    const segments = 100;
    const geometry = new THREE.ShapeGeometry(shape, segments / 2);

    const material = new THREE.MeshBasicMaterial({
      color: "white",
      side: THREE.DoubleSide,
      depthWrite: false
    });

    circle = new THREE.Mesh(geometry, material);
    console.log(circle.position)
    
  },

  setPosition({ x, y }) {
    const a = 5
    circle.position.set(x*a,y*a,-40)
    console.log(circle.position)
    
  },

  render({ riggedFace }) {
    if (!circle) {
      this.initPosition(riggedFace.pupil)
    }
    this.setPosition(riggedFace.pupil)
    renderer.render(scene, camera)
  },

  init_camera_controls(controls) {
    controls.screenSpacePanning = true
    controls.target.set(0.0, 1.35, 0.0)

    controls.minPolarAngle = ((10 / 90) * Math.PI) / 2
    controls.maxPolarAngle = ((105 / 90) * Math.PI) / 2
    controls.update()
  },

  onResize() {
    const width = window.innerWidth
    const height = window.innerHeight

    renderer.setPixelRatio(window.devicePixelRatio)
    renderer.setSize(width, height)

    camera.aspect = width / height
    camera.updateProjectionMatrix()
  },
}

export default target
