package com.example.mymatzip.service;

import com.example.mymatzip.entity.Image;
import com.example.mymatzip.repository.ImageRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Set;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class FileService {

    // [추가] 저장한 파일의 정보(원래 이름, 저장 이름, 크기, 형식)를 image 테이블에 기록합니다.
    private final ImageRepository imageRepository;

    private static final String UPLOAD_DIR = "uploads";
    private static final Set<String> ALLOWED_EXTENSIONS = Set.of("jpg", "jpeg", "png", "gif", "webp");

    public String upload(MultipartFile file) throws IOException {
        if (file.isEmpty()) {
            throw new IllegalArgumentException("파일이 비어있습니다.");
        }

        String originalFilename = file.getOriginalFilename();
        String extension = getExtension(originalFilename).toLowerCase();

        if (!ALLOWED_EXTENSIONS.contains(extension)) {
            throw new IllegalArgumentException("허용되지 않는 파일 형식입니다. (jpg, png, gif, webp만 가능)");
        }

        // uploads 디렉토리 생성
        Path uploadPath = Paths.get(UPLOAD_DIR);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        // UUID로 파일명 변환 (중복 방지)
        String savedFilename = UUID.randomUUID() + "." + extension;
        Path filePath = uploadPath.resolve(savedFilename);

        // 파일 저장
        // [수정] 절대 경로로 저장합니다. 상대 경로를 넘기면 톰캣이 자기 임시 폴더 기준으로 저장해서
        //   WebMvcConfig 의 /uploads/** (프로젝트 폴더의 uploads) 에서 파일을 찾지 못합니다.
        file.transferTo(filePath.toAbsolutePath().toFile());

        // [추가] 업로드 기록 저장
        imageRepository.save(Image.builder()
                .originalFileName(originalFilename)
                .storedFileName(savedFilename)
                .filePath(filePath.toString())
                .fileSize(file.getSize())
                .contentType(file.getContentType())
                .build());

        return "/uploads/" + savedFilename;
    }

    private String getExtension(String filename) {
        if (filename == null || !filename.contains(".")) {
            throw new IllegalArgumentException("파일 확장자를 확인할 수 없습니다.");
        }
        return filename.substring(filename.lastIndexOf(".") + 1);
    }
}
