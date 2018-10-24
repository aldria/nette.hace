<?php

declare(strict_types = 1);

namespace App\Presenters;

use Nette;
use Nette\Application;
use Nette\Application\Responses;
use Nette\Http;
use Tracy\ILogger;

class ErrorPresenter implements Nette\Application\IPresenter
{

    use Nette\SmartObject;

    /** @var ILogger */
    private $logger;

    public function __construct(ILogger $logger)
    {
        $this->logger = $logger;
    }

    public function run(Nette\Application\Request $request): Application\IResponse
    {
        $exception = $request->getParameter('exception');
        $this->logger->log($exception, ILogger::EXCEPTION);

        if ($exception instanceof Nette\Application\BadRequestException) {
            [$module, , $sep] = Nette\Application\Helpers::splitName($request->getPresenterName());

            return new Responses\ForwardResponse($request->setPresenterName($module . $sep . 'Error4xx'));
        }

        return new Responses\CallbackResponse(function (Http\IRequest $httpRequest, Http\IResponse $httpResponse): void {
            $contentType = $httpResponse->getHeader('Content-Type');
            if ($contentType !== null && \preg_match('#^text/html(?:;|$)#', $contentType) === 1) {
                require __DIR__ . '/../templates/Error/500.phtml';
            }
        });
    }

}
