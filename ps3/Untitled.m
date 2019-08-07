clear all; close all; tic;
train       = 0;

if train
    small       = double( imread( 'mandrill-small.tiff' ) );
    size_small  = size( small );
    n_pix       = prod( size_small(1:2) );
    small       = reshape( small, n_pix, 3 ); % rgb
    n_centroids = 16;
    n_iter      = 300;
    centroids           = small( randi(n_pix, n_centroids,1), : );% innitiallize randomly
    dummy_ones          = ones( n_centroids, 1 );
    distortion_fcn      = zeros( n_iter, n_centroids );

    %matlabpool open 4;
    for idx0 = 1:n_iter
        cluster_count       = zeros( n_centroids, 1);
        cluster_total       = zeros( n_centroids, 3);
        for idx1 = 1:n_pix
            temp1 = dummy_ones * small( idx1, : ) - centroids;
            temp2 = zeros( n_centroids, 1 );
            for idx2 = 1:n_centroids
                temp2( idx2 ) = norm( temp1( idx2,: ))^2;
            end
            [minV, cluster_assignment ]                = min( temp2 );
            cluster_count( cluster_assignment )        = cluster_count( cluster_assignment ) + 1;
            cluster_total( cluster_assignment, : )     = cluster_total( cluster_assignment, : ) + small( idx1, : );
            distortion_fcn( idx0, cluster_assignment ) = distortion_fcn( idx0, cluster_assignment ) + minV;
        end
        centroids = cluster_total ./ (cluster_count*[1 1 1]);
    end
    %matlabpool close;
    semilogy((1:n_iter)',distortion_fcn);xlabel('iterations');title('distortion functions for different centroids');
else
    load untitled;
    large            = double( imread( 'mandrill-large.tiff' ) );
    size_large       = size( large );
    n_pix            = prod( size_large(1:2) );
    large            = reshape( large, n_pix, 3 ); % rgb
    large_classified = zeros( n_pix, 3 );
    n_centroids      = 16;
    dummy_ones       = ones( n_centroids, 1 );
    for idx1 = 1:n_pix
        temp1 = dummy_ones * large( idx1, : ) - centroids;
        temp2 = zeros( n_centroids, 1 );
        for idx2 = 1:n_centroids
            temp2( idx2 ) = norm( temp1( idx2,: ));
        end
        [~, cluster_assignment ]    = min( temp2 );
        large_classified( idx1, : ) = centroids( cluster_assignment, : );
    end
    large            = reshape( large, size_large );
    large_classified = reshape( large_classified, size_large );
    figure(2);
    subplot(1,2,1); imagesc( large/255 );            axis equal; axis off; title('mandrill-large.tiff');
    subplot(1,2,2); imagesc( large_classified/255 ); axis equal; axis off; title('after compression');
    
end
toc;