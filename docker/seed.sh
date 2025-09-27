#!/bin/sh

echo "🌱 Starting database seeding process..."

# Wait for the Next.js app to be ready
echo "⏳ Waiting for Next.js application to be ready..."
while ! curl -f http://app:3000/api/seed > /dev/null 2>&1; do
  echo "⏳ App not ready yet, waiting 5 seconds..."
  sleep 5
done

echo "✅ Next.js application is ready!"

# Call the seed endpoint
echo "🌱 Seeding database with sample data..."
response=$(curl -s -w "\n%{http_code}" http://app:3000/api/seed)
http_code=$(echo "$response" | tail -n1)
body=$(echo "$response" | head -n -1)

if [ "$http_code" = "200" ]; then
  # Check if seeding was skipped or completed
  if echo "$body" | grep -q '"skipped":true'; then
    echo "⏭️  Database already contains data, skipping seed."
  else
    echo "✅ Database seeded successfully!"
  fi
  echo "📄 Response: $body"
else
  echo "❌ Seeding failed with HTTP code: $http_code"
  echo "📄 Response: $body"
  exit 1
fi

echo "🎉 Seeding process completed!"