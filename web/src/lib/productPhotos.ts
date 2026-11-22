import demoPhotos from "./demoProductPhotos.json";

interface ProductPhotoSource {
  product_id: number;
  name: string;
  image_url: string | null;
}

const demoProducts: Partial<Record<number, Omit<ProductPhotoSource, "product_id">>> = demoPhotos;

export function productPhotoUrl(product: ProductPhotoSource): string | null {
  const demo = demoProducts[product.product_id];
  if (demo && demo.name === product.name && demo.image_url === product.image_url) {
    return `/assets/product-photos/${product.product_id}.webp`;
  }
  return product.image_url;
}
