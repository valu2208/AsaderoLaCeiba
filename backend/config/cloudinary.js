
import { v2 as cloudinary } from 'cloudinary';
import multer from 'multer';
import { CloudinaryStorage } from 'multer-storage-cloudinary';

// Configuración de Cloudinary.
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});

// IMÁGENES DE PRODUCTOS

const storage = new CloudinaryStorage({
  cloudinary,
  params: {
    folder: 'asadero_la_ceiba/productos',
    allowed_formats: ['jpg', 'jpeg', 'png', 'webp', 'avif'],
  },
});

export const upload = multer({
  storage,
  limits: {
    fileSize: 50 * 1024 * 1024,
  },
});

//FOTOS DE PERFIL

const avatarStorage = new CloudinaryStorage({
  cloudinary,
  params: {
    folder: 'asadero_la_ceiba/avatares',
    allowed_formats: ['jpg', 'jpeg', 'png', 'webp'],
  },
});

export const uploadAvatar = multer({
  storage: avatarStorage,
  limits: {
    fileSize: 5 * 1024 * 1024,
  },
});

//COMPROBANTES DE PAGO

export const uploadComprobante = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: 8 * 1024 * 1024,
  },
  fileFilter: (req, file, cb) => {
    const permitidos = ['image/jpeg', 'image/png', 'image/webp'];

    if (permitidos.includes(file.mimetype)) {
      cb(null, true);
    } else {
      cb(new Error('Formato de imagen no permitido.'));
    }
  },
});

export const subirComprobanteCloudinary = (buffer) => {
  return new Promise((resolve, reject) => {
    const stream = cloudinary.uploader.upload_stream(
      {
        folder: 'asadero_la_ceiba/comprobantes',
        resource_type: 'image',
      },
      (error, result) => {
        if (error) {
          reject(error);
        } else {
          resolve(result.secure_url);
        }
      }
    );

    stream.end(buffer);
  });
};

export default cloudinary;
