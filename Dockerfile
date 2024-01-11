LABEL org.opencontainers.image.source https://github.com/Syntax3rror404/revealjs-helm
# Use the official Nginx image as a base
FROM nginx:alpine

# Set the working directory
WORKDIR /usr/share/nginx/html

# Remove any default hosted files
RUN rm -rf ./*

# Install necessary packages to download and extract the tarball
RUN apk add --no-cache curl tar

# Download and unpack Reveal.js into the working directory
RUN curl -L https://github.com/hakimel/reveal.js/archive/refs/tags/5.0.4.tar.gz | tar xz --strip-components=1

# # Change ownership of directories to support non-root user
# RUN chown -R nginx:nginx /usr/share/nginx/html

# # Switch to non-root user
# USER 101

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
