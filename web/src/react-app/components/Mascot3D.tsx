import { useRef } from 'react';
import { useFrame } from '@react-three/fiber';
import { Float } from '@react-three/drei';
import * as THREE from 'three';

function BookMascot() {
  const meshRef = useRef<THREE.Mesh>(null);
  
  useFrame((_, delta) => {
    if (meshRef.current) {
      meshRef.current.rotation.y += delta * 0.5;
    }
  });

  return (
    <Float speed={2} rotationIntensity={0.1} floatIntensity={0.2}>
      <mesh ref={meshRef} position={[0, 0, 0]}>
        {/* Book body */}
        <boxGeometry args={[2, 2.5, 0.3]} />
        <meshStandardMaterial color="#FF7828" />
        
        {/* Book pages */}
        <mesh position={[0.1, 0, 0.16]}>
          <boxGeometry args={[1.8, 2.3, 0.2]} />
          <meshStandardMaterial color="#ffffff" />
        </mesh>
        
        {/* Eyes */}
        <mesh position={[-0.3, 0.5, 0.2]}>
          <sphereGeometry args={[0.15]} />
          <meshStandardMaterial color="#ffffff" />
          <mesh position={[0, 0, 0.1]}>
            <sphereGeometry args={[0.08]} />
            <meshStandardMaterial color="#000000" />
          </mesh>
        </mesh>
        
        <mesh position={[0.3, 0.5, 0.2]}>
          <sphereGeometry args={[0.15]} />
          <meshStandardMaterial color="#ffffff" />
          <mesh position={[0, 0, 0.1]}>
            <sphereGeometry args={[0.08]} />
            <meshStandardMaterial color="#000000" />
          </mesh>
        </mesh>
        
        {/* Smile */}
        <mesh position={[0, 0.1, 0.2]} rotation={[0, 0, Math.PI]}>
          <torusGeometry args={[0.3, 0.05, 8, 16, Math.PI]} />
          <meshStandardMaterial color="#000000" />
        </mesh>
      </mesh>
    </Float>
  );
}

export default function Mascot3D({ }: { animate?: boolean }) {
  return (
    <group>
      <BookMascot />
      <ambientLight intensity={0.5} />
      <pointLight position={[10, 10, 10]} intensity={1} />
    </group>
  );
}
