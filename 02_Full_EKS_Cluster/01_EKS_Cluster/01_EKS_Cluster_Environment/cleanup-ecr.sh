#!/bin/bash
REPOS=("retail-store/cart" "retail-store/catalog" "retail-store/checkout" "retail-store/orders" "retail-store/ui")

for repo in "${REPOS[@]}"; do
  echo "=== Cleaning $repo ==="

  # Delete all images in the repository
  echo "  Deleting all images..."
  IMAGE_IDS=$(aws ecr list-images --repository-name $repo --query 'imageIds[*]' --output json 2>/dev/null || echo "[]")
  
  if [ "$IMAGE_IDS" != "[]" ]; then
    aws ecr batch-delete-image \
      --repository-name $repo \
      --image-ids "$IMAGE_IDS" || true
  fi

  # Final force delete of the repository
  echo "  Force deleting repository..."
  aws ecr delete-repository --repository-name $repo --force || true

  echo "  Done with $repo"
  echo ""
done

echo "=== All repositories cleaned! ==="
