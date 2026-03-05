# Step 1: Use the lightweight Nginx image as the base
FROM nginx:alpine

# Step 2: Copy your specific frontend file into the Nginx HTML directory
# This replaces the default Nginx page with your assignment page
COPY index.html /usr/share/nginx/html/index.html

# Step 3: Inform Docker that the container listens on port 80 at runtime
EXPOSE 80

# Step 4: Nginx starts automatically, so no CMD is strictly required here