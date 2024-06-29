use std::vec;

use image::{DynamicImage, GenericImageView, Rgba};
use rand::Rng;

#[no_mangle]
pub unsafe extern "C" fn extract_palette(
    img_path_ptr: *mut u8,
    img_path_len: usize,
    k: u8,
    max_iterations: u8,
) -> *const u8 {
    let image_path = String::from_raw_parts(img_path_ptr, img_path_len, img_path_len);
    println!("Image path: {}", image_path);
    let img = image::open(image_path).unwrap();
    let img = img.resize(512, 512, image::imageops::FilterType::Nearest);

    let palette = perform_kmeans(&img, k, max_iterations);
    let flattened_palette = palette.iter().flat_map(|c| c.0).collect::<Vec<u8>>();

    println!("Palette: {:?}", &flattened_palette);

    flattened_palette.as_ptr()
}

fn extract_centroids(img: &DynamicImage, k: u8) -> Vec<Rgba<u8>> {
    let mut centroids = vec![];
    let mut rng = rand::thread_rng();
    for _ in 0..k {
        let pixel = img.get_pixel(
            rng.gen_range(0..img.width() - 1),
            rng.gen_range(0..img.height() - 1),
        );

        centroids.push(pixel);
    }

    centroids
}

fn perform_kmeans(img: &DynamicImage, k: u8, max_iterations: u8) -> Vec<Rgba<u8>> {
    let centroids = extract_centroids(img, k);

    if max_iterations == 0 {
        return centroids;
    }

    let mut clusters: Vec<Vec<Rgba<u8>>> = centroids
        .as_slice()
        .iter()
        .map(|centroid| vec![*centroid])
        .collect();

    for pixel in img.pixels() {
        let channels = pixel.2;
        let mut min_distance = calculate_distance(channels, centroids[0]);
        let mut matching_centroid_index = 0;

        for (i, centroid) in centroids.iter().enumerate() {
            let distance = calculate_distance(channels, *centroid);
            if distance < min_distance {
                min_distance = distance;
                matching_centroid_index = i;
            }
        }

        clusters[matching_centroid_index].push(channels);
    }

    for cluster in &mut clusters {
        let average_color = calculate_average_color(cluster);
        cluster.clear();
        cluster.push(average_color);
    }

    perform_kmeans(img, k, max_iterations - 1)
}

fn calculate_distance(a: Rgba<u8>, b: Rgba<u8>) -> f32 {
    let [r1, g1, b1, a1] = a.0;
    let [r2, g2, b2, a2] = b.0;
    ((f32::from(r1) - f32::from(r2)).powi(2)
        + (f32::from(g1) - f32::from(g2)).powi(2)
        + (f32::from(b1) - f32::from(b2)).powi(2)
        + (f32::from(a1) - f32::from(a2)).powi(2))
    .sqrt()
}

fn calculate_average_color(pixels: &[Rgba<u8>]) -> Rgba<u8> {
    let pixels_amount: u32 = pixels.len().try_into().unwrap();
    let (r_total, g_total, b_total, a_total) = pixels.iter().fold(
        (0u32, 0u32, 0u32, 0u32),
        |(r_acc, g_acc, b_acc, a_acc), Rgba([r, g, b, a])| {
            (
                r_acc + u32::from(*r),
                g_acc + u32::from(*g),
                b_acc + u32::from(*b),
                a_acc + u32::from(*a),
            )
        },
    );

    let r_avg: u8 = (r_total / pixels_amount).try_into().unwrap();
    let g_avg: u8 = (g_total / pixels_amount).try_into().unwrap();
    let b_avg: u8 = (b_total / pixels_amount).try_into().unwrap();
    let a_avg: u8 = (a_total / pixels_amount).try_into().unwrap();

    Rgba([r_avg, g_avg, b_avg, a_avg])
}
